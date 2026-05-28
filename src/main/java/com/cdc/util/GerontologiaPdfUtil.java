package com.cdc.util;

import java.awt.Color;
import java.io.OutputStream;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.openpdf.text.Chunk;
import org.openpdf.text.Document;
import org.openpdf.text.DocumentException;
import org.openpdf.text.Element;
import org.openpdf.text.Font;
import org.openpdf.text.FontFactory;
import org.openpdf.text.PageSize;
import org.openpdf.text.Paragraph;
import org.openpdf.text.Phrase;
import org.openpdf.text.Rectangle;
import org.openpdf.text.pdf.PdfPCell;
import org.openpdf.text.pdf.PdfPTable;
import org.openpdf.text.pdf.PdfPageEventHelper;
import org.openpdf.text.pdf.PdfWriter;

import com.cdc.model.GerontologiaConsulta;
import com.cdc.model.GerontologiaPaciente;

public final class GerontologiaPdfUtil {

    private static final Color COLOR_PRIMARIO = new Color(118, 15, 56);
    private static final Color COLOR_PRIMARIO_CLARO = new Color(247, 237, 242);
    private static final Color COLOR_BORDE = new Color(220, 220, 220);
    private static final Color COLOR_TEXTO = new Color(45, 45, 45);
    private static final Color COLOR_MUTED = new Color(100, 100, 100);
    private static final Color COLOR_FONDO_SUAVE = new Color(250, 248, 249);

    private static final Font FONT_TITULO = FontFactory.getFont(FontFactory.HELVETICA, 17, Font.BOLD, COLOR_PRIMARIO);
    private static final Font FONT_SUBTITULO = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL, COLOR_MUTED);
    private static final Font FONT_SECCION = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, COLOR_PRIMARIO);
    private static final Font FONT_ETIQUETA = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, COLOR_MUTED);
    private static final Font FONT_VALOR = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, COLOR_TEXTO);
    private static final Font FONT_VALOR_NEGRITA = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD, COLOR_TEXTO);
    private static final Font FONT_TEXTO = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, COLOR_TEXTO);
    private static final Font FONT_PIE = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, COLOR_MUTED);

    private static final DateTimeFormatter FORMATO_FECHA = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FORMATO_FECHA_HORA = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private GerontologiaPdfUtil() {
    }

    public static void generarPdfConsulta(
            OutputStream outputStream,
            GerontologiaPaciente paciente,
            GerontologiaConsulta consulta
    ) throws DocumentException {

        Document document = crearDocumento();
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
        writer.setPageEvent(new EventoPiePagina("Consulta de Gerontología"));

        document.open();

        agregarEncabezado(
                document,
                "Consulta de Gerontología",
                "Documento individual de consulta"
        );

        agregarDatosPaciente(document, paciente);
        agregarDatosConsultaIndividual(document, consulta);

        agregarAvisoFinal(document);

        document.close();
    }

    public static void generarPdfHistorial(
            OutputStream outputStream,
            GerontologiaPaciente paciente,
            List<GerontologiaConsulta> consultas
    ) throws DocumentException {

        Document document = crearDocumento();
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
        writer.setPageEvent(new EventoPiePagina("Historial de Gerontología"));

        document.open();

        agregarEncabezado(
                document,
                "Historial de Gerontología",
                "Expediente completo del paciente"
        );

        agregarDatosPaciente(document, paciente);
        agregarResumenHistorial(document, consultas);
        agregarConsultasHistorial(document, consultas);

        agregarAvisoFinal(document);

        document.close();
    }

    private static Document crearDocumento() {
        return new Document(PageSize.LETTER, 42, 42, 54, 44);
    }

    private static void agregarEncabezado(Document document, String titulo, String subtitulo)
            throws DocumentException {

        PdfPTable tabla = new PdfPTable(new float[]{3.2f, 1.3f});
        tabla.setWidthPercentage(100);

        PdfPCell celdaTitulo = new PdfPCell();
        celdaTitulo.setBorder(Rectangle.NO_BORDER);
        celdaTitulo.setPaddingBottom(10);

        Paragraph nombreCentro = new Paragraph("CDC Plan Chac", FONT_TITULO);
        nombreCentro.setSpacingAfter(3);
        celdaTitulo.addElement(nombreCentro);

        Paragraph modulo = new Paragraph("Módulo de Gerontología", FONT_SUBTITULO);
        celdaTitulo.addElement(modulo);

        Paragraph documento = new Paragraph(titulo, FONT_SECCION);
        documento.setSpacingBefore(8);
        celdaTitulo.addElement(documento);

        Paragraph descripcion = new Paragraph(subtitulo, FONT_SUBTITULO);
        celdaTitulo.addElement(descripcion);

        PdfPCell celdaFecha = new PdfPCell();
        celdaFecha.setBorder(Rectangle.NO_BORDER);
        celdaFecha.setHorizontalAlignment(Element.ALIGN_RIGHT);
        celdaFecha.setVerticalAlignment(Element.ALIGN_TOP);
        celdaFecha.setPaddingTop(3);

        Paragraph etiquetaFecha = new Paragraph("Fecha de emisión", FONT_ETIQUETA);
        etiquetaFecha.setAlignment(Element.ALIGN_RIGHT);

        Paragraph valorFecha = new Paragraph(
                java.time.LocalDate.now().format(FORMATO_FECHA),
                FONT_VALOR_NEGRITA
        );
        valorFecha.setAlignment(Element.ALIGN_RIGHT);

        celdaFecha.addElement(etiquetaFecha);
        celdaFecha.addElement(valorFecha);

        tabla.addCell(celdaTitulo);
        tabla.addCell(celdaFecha);

        document.add(tabla);

        PdfPTable linea = new PdfPTable(1);
        linea.setWidthPercentage(100);

        PdfPCell celdaLinea = new PdfPCell(new Phrase(" "));
        celdaLinea.setBorder(Rectangle.BOTTOM);
        celdaLinea.setBorderColor(COLOR_PRIMARIO);
        celdaLinea.setBorderWidth(1.3f);
        celdaLinea.setFixedHeight(8);
        linea.addCell(celdaLinea);

        document.add(linea);
        agregarEspacio(document, 12);
    }

    private static void agregarDatosPaciente(Document document, GerontologiaPaciente paciente)
            throws DocumentException {

        agregarTituloSeccion(document, "Datos del paciente");

        PdfPTable tabla = new PdfPTable(new float[]{1.2f, 2.4f, 1.2f, 2.2f});
        tabla.setWidthPercentage(100);
        tabla.setSpacingAfter(12);

        agregarCampo(tabla, "Nombre", valor(paciente.getNombreCompleto()));
        agregarCampo(tabla, "CURP", valor(paciente.getCurp()));

        agregarCampo(tabla, "Teléfono", valor(paciente.getCelular()));
        agregarCampo(tabla, "Nacimiento", formatearFecha(paciente.getFechaNacimiento()));

        agregarCampo(tabla, "Edad actual", paciente.getEdad() + " años");
        agregarCampo(tabla, "Estado", valor(paciente.getEstadoPaciente()));

        agregarCampo(tabla, "Creación", formatearFechaHora(paciente.getFechaCreacion()));
        agregarCampo(tabla, "Última actualización", formatearFechaHora(paciente.getFechaActualizacion()));

        document.add(tabla);
    }

    private static void agregarDatosConsultaIndividual(Document document, GerontologiaConsulta consulta)
            throws DocumentException {

        agregarTituloSeccion(document, "Datos de la consulta");

        PdfPTable tabla = new PdfPTable(new float[]{1.3f, 2.3f, 1.3f, 2.1f});
        tabla.setWidthPercentage(100);
        tabla.setSpacingAfter(12);

        agregarCampo(tabla, "Fecha y hora", formatearFechaHora(consulta.getFechaConsulta()));
        agregarCampo(tabla, "Edad registrada", consulta.getEdadPacienteSnapshot() + " años");

        document.add(tabla);

        agregarBloqueTexto(document, "Motivo de consulta", consulta.getMotivoConsulta());
        agregarBloqueTexto(document, "Antecedentes", consulta.getAntecedentes());
        agregarBloqueTexto(document, "Notas", consulta.getNotas());
    }

    private static void agregarResumenHistorial(
            Document document,
            List<GerontologiaConsulta> consultas
    ) throws DocumentException {

        agregarTituloSeccion(document, "Resumen del historial");

        int totalConsultas = consultas == null ? 0 : consultas.size();

        PdfPTable tabla = new PdfPTable(new float[]{1.5f, 2.5f, 1.5f, 2.5f});
        tabla.setWidthPercentage(100);
        tabla.setSpacingAfter(12);

        agregarCampo(tabla, "Total de consultas", String.valueOf(totalConsultas));

        if (totalConsultas > 0) {
            GerontologiaConsulta ultimaConsulta = consultas.get(0);
            agregarCampo(tabla, "Última consulta", formatearFechaHora(ultimaConsulta.getFechaConsulta()));
        } else {
            agregarCampo(tabla, "Última consulta", "Sin consultas registradas");
        }

        document.add(tabla);
    }

    private static void agregarConsultasHistorial(
            Document document,
            List<GerontologiaConsulta> consultas
    ) throws DocumentException {

        agregarTituloSeccion(document, "Consultas registradas");

        if (consultas == null || consultas.isEmpty()) {
            Paragraph vacio = new Paragraph(
                    "Este expediente todavía no tiene consultas registradas.",
                    FONT_TEXTO
            );
            vacio.setSpacingAfter(10);
            document.add(vacio);
            return;
        }

        int contador = 1;

        for (GerontologiaConsulta consulta : consultas) {
            agregarConsultaHistorial(document, consulta, contador);
            contador++;
        }
    }

    private static void agregarConsultaHistorial(
            Document document,
            GerontologiaConsulta consulta,
            int numero
    ) throws DocumentException {

        PdfPTable tarjeta = new PdfPTable(1);
        tarjeta.setWidthPercentage(100);
        tarjeta.setSpacingBefore(4);
        tarjeta.setSpacingAfter(12);

        PdfPCell contenedor = new PdfPCell();
        contenedor.setBorder(Rectangle.BOX);
        contenedor.setBorderColor(COLOR_BORDE);
        contenedor.setPadding(12);
        contenedor.setBackgroundColor(COLOR_FONDO_SUAVE);

        Paragraph titulo = new Paragraph(
                "Consulta " + numero + "  ·  " + formatearFechaHora(consulta.getFechaConsulta()),
                FONT_SECCION
        );
        titulo.setSpacingAfter(8);
        contenedor.addElement(titulo);

        Paragraph edad = new Paragraph(
                "Edad registrada: " + consulta.getEdadPacienteSnapshot() + " años",
                FONT_SUBTITULO
        );
        edad.setSpacingAfter(8);
        contenedor.addElement(edad);

        agregarBloqueTextoACelda(contenedor, "Motivo de consulta", consulta.getMotivoConsulta());
        agregarBloqueTextoACelda(contenedor, "Antecedentes", consulta.getAntecedentes());
        agregarBloqueTextoACelda(contenedor, "Notas", consulta.getNotas());

        tarjeta.addCell(contenedor);
        document.add(tarjeta);
    }

    private static void agregarTituloSeccion(Document document, String titulo)
            throws DocumentException {

        PdfPTable tabla = new PdfPTable(1);
        tabla.setWidthPercentage(100);
        tabla.setSpacingBefore(6);
        tabla.setSpacingAfter(8);

        PdfPCell celda = new PdfPCell(new Phrase(titulo, FONT_SECCION));
        celda.setBorder(Rectangle.NO_BORDER);
        celda.setBackgroundColor(COLOR_PRIMARIO_CLARO);
        celda.setPadding(8);

        tabla.addCell(celda);
        document.add(tabla);
    }

    private static void agregarCampo(PdfPTable tabla, String etiqueta, String valor) {
        PdfPCell celdaEtiqueta = new PdfPCell(new Phrase(etiqueta, FONT_ETIQUETA));
        celdaEtiqueta.setBorder(Rectangle.BOX);
        celdaEtiqueta.setBorderColor(COLOR_BORDE);
        celdaEtiqueta.setBackgroundColor(COLOR_PRIMARIO_CLARO);
        celdaEtiqueta.setPadding(7);

        PdfPCell celdaValor = new PdfPCell(new Phrase(valor(valor), FONT_VALOR));
        celdaValor.setBorder(Rectangle.BOX);
        celdaValor.setBorderColor(COLOR_BORDE);
        celdaValor.setPadding(7);

        tabla.addCell(celdaEtiqueta);
        tabla.addCell(celdaValor);
    }

    private static void agregarBloqueTexto(Document document, String titulo, String texto)
            throws DocumentException {

        PdfPTable tabla = new PdfPTable(1);
        tabla.setWidthPercentage(100);
        tabla.setSpacingAfter(10);

        PdfPCell celdaTitulo = new PdfPCell(new Phrase(titulo, FONT_ETIQUETA));
        celdaTitulo.setBorder(Rectangle.BOX);
        celdaTitulo.setBorderColor(COLOR_BORDE);
        celdaTitulo.setBackgroundColor(COLOR_PRIMARIO_CLARO);
        celdaTitulo.setPadding(7);

        PdfPCell celdaTexto = new PdfPCell(new Phrase(valor(texto), FONT_TEXTO));
        celdaTexto.setBorder(Rectangle.BOX);
        celdaTexto.setBorderColor(COLOR_BORDE);
        celdaTexto.setPadding(9);
        celdaTexto.setMinimumHeight(34);

        tabla.addCell(celdaTitulo);
        tabla.addCell(celdaTexto);

        document.add(tabla);
    }

    private static void agregarBloqueTextoACelda(PdfPCell contenedor, String titulo, String texto) {
        Paragraph etiqueta = new Paragraph(titulo, FONT_ETIQUETA);
        etiqueta.setSpacingBefore(6);
        etiqueta.setSpacingAfter(3);

        Paragraph contenido = new Paragraph(valor(texto), FONT_TEXTO);
        contenido.setSpacingAfter(5);

        contenedor.addElement(etiqueta);
        contenedor.addElement(contenido);
    }

    private static void agregarAvisoFinal(Document document) throws DocumentException {
        agregarEspacio(document, 8);

        Paragraph aviso = new Paragraph(
                "Documento generado desde el Sistema de Gestión del Centro Comunitario CDC Plan Chac.",
                FONT_PIE
        );
        aviso.setAlignment(Element.ALIGN_CENTER);
        document.add(aviso);
    }

    private static void agregarEspacio(Document document, float alto) throws DocumentException {
        Paragraph espacio = new Paragraph(new Chunk(" "));
        espacio.setSpacingAfter(alto);
        document.add(espacio);
    }

    private static String formatearFecha(Date fecha) {
        if (fecha == null) {
            return "--";
        }

        return fecha.toLocalDate().format(FORMATO_FECHA);
    }

    private static String formatearFechaHora(Timestamp fechaHora) {
        if (fechaHora == null) {
            return "--";
        }

        return fechaHora.toLocalDateTime().format(FORMATO_FECHA_HORA);
    }

    private static String valor(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return "--";
        }

        return valor.trim();
    }

    private static class EventoPiePagina extends PdfPageEventHelper {

        private final String tipoDocumento;

        private EventoPiePagina(String tipoDocumento) {
            this.tipoDocumento = tipoDocumento;
        }

        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfPTable pie = new PdfPTable(new float[]{3f, 1f});

            try {
                pie.setTotalWidth(document.right() - document.left());

                PdfPCell izquierda = new PdfPCell(new Phrase(tipoDocumento + " · CDC Plan Chac", FONT_PIE));
                izquierda.setBorder(Rectangle.TOP);
                izquierda.setBorderColor(COLOR_BORDE);
                izquierda.setPaddingTop(5);

                PdfPCell derecha = new PdfPCell(new Phrase("Página " + writer.getPageNumber(), FONT_PIE));
                derecha.setBorder(Rectangle.TOP);
                derecha.setBorderColor(COLOR_BORDE);
                derecha.setHorizontalAlignment(Element.ALIGN_RIGHT);
                derecha.setPaddingTop(5);

                pie.addCell(izquierda);
                pie.addCell(derecha);

                pie.writeSelectedRows(
                        0,
                        -1,
                        document.left(),
                        document.bottom() - 8,
                        writer.getDirectContent()
                );
            } catch (Exception e) {
                // No se interrumpe la generación del PDF si falla el pie de página.
            }
        }
    }
}