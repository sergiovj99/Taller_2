---1. Almacenar, actualizar o eliminar el formulario de la EAD. 
---Se deben realizar las validaciones pertinentes de acuerdo al dominio de valores de cada campo. 
---Si no se cumplen se debe retornar un error indicando los errores encontrados.

create procedure primero_validar(

@IdPaciente int,      
@IdRango int,  
@IdItem int,
@Respuesta int, 
@IdRespuestaAL int 
)

as 
if exists (select * from RespuestaAL where IdPaciente= IdPaciente)
begin
print('Ya existe este paciente con esta respuesta')
return
end

begin
insert into RespuestaAL values(
@IdPaciente,      
@IdRango,  
@IdItem,
@Respuesta, 
@IdRespuestaAL
)
end
 
 ---2. Almacenar, actualizar o eliminar la tabla de conversión PD a PT de motricidad gruesa, fino adaptativa,
---área audición lenguaje, área personal social. Se deben realizar las validaciones pertinentes de acuerdo al dominio
---de valores de cada campo. Si no se cumplen se debe retornar un error indicando los errores encontrados.



create procedure segundo_validar(
@Total_Acumulado int,
@N_items_correctos int,
@total int
)
as
begin
CREATE TABLE PTAudicion (

PrID int PRIMARY KEY NOT NULL,
Total_Acumulado int,
N_items_correctos int,
total int
)

insert into PTAudicion ( 
     SELECT IdRangos, SUM(PuntuacionDirecta)
     FROM ConversionAudicionLenguaje  
     WHERE IdRangos IS NOT NULL   
          AND PuntuacionDirecta != 0.00   
      
     GROUP BY   IdRangos
     ORDER BY IdRangos; ) 
end
begin
CREATE TABLE PTmotricidad (

PrID int PRIMARY KEY NOT NULL,
Total_Acumulado int,
N_items_correctos int,
total int
)

insert into PTmoticidad ( 
     SELECT IdRangos, SUM(PuntuacionDirecta)
     FROM ConversionAudicionLenguaje  
     WHERE IdRangos IS NOT NULL   
          AND PuntuacionDirecta != 0.00   
      
     GROUP BY   IdRangos
     ORDER BY IdRangos; ) 
end

---3. Almacenar, actualizar o eliminar el formulario de puntuación de la EAD. 
---Se deben realizar las validaciones pertinentes de acuerdo al dominio de valores de cada campo. 
---Si no se cumplen se debe retornar un error indicando los errores encontrados.


create procedure tercero_validar(

@IdTipoDoc int,      
@NumeroIdentificacion int,  
@PromerNombre nvarchar(50),
@SegundoNombre nvarchar(50), 
@PrimerApellido nvarchar(50), 
@SegundoApellido nvarchar(50),
@CodigoEntidad int,
@IdTipoUsuario int,
@IdEtnia int,
@IdGrupoDif int,
@CodigDep int,
@IdZona int,
@Sexo nvarchar(50),
@Edad int

)
as 
if @IdTipoDoc= 100
begin
insert into PuntuacionEscala values(

@IdTipoDoc,      
@NumeroIdentificacion,  
@PromerNombre ,
@SegundoNombre , 
@PrimerApellido , 
@SegundoApellido ,
@CodigoEntidad ,
@IdTipoUsuario ,
@IdEtnia ,
@IdGrupoDif ,
@CodigDep ,
@IdZona ,
@Sexo ,
@Edad 

)

execute tercero_validar 101,	1020,	'Marcela',	'Maria',	'Reyes',	'Acosta',	102,	101,	2,	101,	114,	104,	'F',	45
end

if @IdTipoDoc= 101
begin 
update PuntuacionEscala  SET PromerNombre = @PromerNombre
WHERE @IdTipoDoc = 101;
END

BEGIN 
DELETE FROM PuntuacionEscala  WHERE @IdTipoDoc = 101
END


---4. Almacenar, actualizar o eliminar el formulario de vacunación y el esquema de vacunación de acuerdo al rango de edad. 
---Se deben realizar las validaciones pertinentes de acuerdo al dominio de valores de cada campo. Si no se cumplen se debe
--retornar un error indicando los errores encontrados.
create procedure cuarto 
as 
begin
select * from EsquemaVacunacionAdultos as e
inner join VacunasAdultos as v
on e.IdVacuna = v.IdVacuna
where e.Edad>18
end

---5.Obtener el formulario de EAD. Debe permitir filtro por fechas o número de documento. 
---Mostrar el total acumulado al inicio, número de ítems correctos y el total de puntaje directo.
---Mostrar el resultado por secciones: Motricidad Gruesa, Motricidad Fino Adaptativa, Audición y Lenguaje, Personal Social.
---Debe permitir filtro por fechas o número de documento



---6.Obtener la tabla de conversión PD a PT de motricidad gruesa, fino adaptativa, área audición lenguaje, área personal social. 
---Debe permitir filtro por fechas o número de documento.

create procedure sexto
as
begin
select * from RespuestaAL as c
inner join PuntuacionEscala as p
on c.IdPaciente=p.IdPaciente
where NumeroIdentificacion = 1020
end


---7.Obtener el formulario de puntuación de la EAD. Debe permitir filtro por fechas o número de documento.
create procedure septimo
as
begin
select * from  PuntuacionEscala as p
where NumeroIdentificacion = 1020 
end

---8.Obtener el formulario de vacunación y esquema de vacunación de acuerdo al rango de edad. 
---Debe permitir filtro por fechas o número de documento.
create procedure octavo
as
begin
select * from VacunasAdultos as c
inner join EsquemaVacunacionAdultos as p
on c.IdVacuna=p.IdVacuna
where p.NumeroIdentificacion = 100000
end
---9.Obtener cual es la pregunta de EAD que más puntaje tiene.
create procedure noveno
as 
begin
select max(ValorRango) as MayorPuntaje
from ConversionAudicionLenguaje
end
---10.Obtener cuales adultos tienen el esquema completo de vacunación.
create procedure decimo
as 
begin

select * from EsquemaVacunacionAdultos
where IdTipoDosis=104
end